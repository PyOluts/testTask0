import { createFileRoute, redirect } from "@tanstack/react-router"
import { UsersService } from "@/client"

export const Route = createFileRoute("/_layout/metrics")({
  component: Metrics,
  beforeLoad: async () => {
    const user = await UsersService.readUserMe()
    if (!["admin", "manager"].includes(user.role || "")) {
      throw redirect({
        to: "/",
      })
    }
  },
  head: () => ({
    meta: [
      {
        title: "Metrics - FastAPI Template",
      },
    ],
  }),
})

function Metrics() {
  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Metrics</h1>
          <p className="text-muted-foreground">
            View system metrics and insights.
          </p>
        </div>
      </div>
      <div className="rounded-md border p-8 bg-card text-card-foreground shadow-sm flex items-center justify-center">
        <p className="text-lg">Metrics Dashboard coming soon...</p>
      </div>
    </div>
  )
}
